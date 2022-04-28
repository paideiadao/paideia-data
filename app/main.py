import subprocess
import shlex
import boto3
                    
from os import getenv, listdir, remove
from pydantic import BaseModel
from typing import Optional
from datetime import datetime, timedelta
from botocore.client import Config

### INIT
BACKUP_DIR = 'backups/ergopad'
S3_BUCKET = 'ergopad-backup'
DEBUG = True

now = datetime.now()

""" Backups
 - daily for 2 weeks
 - weekly for 2 months
 - monthly for 2 years
 - annually
"""

import argparse
parser = argparse.ArgumentParser(description='Process maintenance interval')
parser.add_argument('-i', '--interval', choices=['daily', 'weekly', 'monthly', 'annually'], default='daily')
args = parser.parse_args()

#region LOGGING
import logging
level = (logging.WARN, logging.DEBUG)[DEBUG]
logging.basicConfig(format='{asctime}:{name:>8s}:{levelname:<8s}::{message}', style='{', level=level)

import inspect
myself = lambda: inspect.stack()[1][3]
#endregion LOGGING

s3 = boto3.resource(
    's3',
    aws_access_key_id = getenv("AWS_ACCESS_KEY_ID"),
    aws_secret_access_key = getenv("AWS_SECRET_ACCESS_KEY"),
    config = Config(signature_version='s3v4')
)

class SqlDatabase(BaseModel):
    name: str
    host: str
    port: int
    user: str
    password: str
    database: str

# backup by servers
SQL = []
for db in getenv('POSTGRES_ALPHA_DATABASES').split(','):
    SQL.append(SqlDatabase(name='alpha', host=getenv('POSTGRES_ALPHA_HOST'), port=getenv('POSTGRES_ALPHA_PORT'), user=getenv('POSTGRES_ALPHA_USER'), password=getenv('POSTGRES_ALPHA_PASSWORD'), database=db))

### FUNCTIONS
# send to s3
def upload(src, key, removeSourceFile:bool = False):
    try:
        logging.debug(f'uploading {src} to {key}')
        res = s3.Bucket(S3_BUCKET).upload_file(src, key)
        
        if removeSourceFile:
            logging.debug(f'removing {src}')
            os.remove(src)

        return {'status': 'success', 'message': 'upload'}

    except boto3.exceptions.S3UploadFailedError as e:
        logging.error(e)
        
# backup databases to files
def backup(db:SqlDatabase, interval:str, backupToS3:bool = True):
    if interval not in ['daily', 'weekly', 'monthly', 'annually']:
        return {'status': 'error', 'message': f'invalid interval specified: {interval}, needs to be daily, weekly, monthly or annually.'}

    try:
        dbname = f'postgresql://{db.user}:{db.password}@{db.host}:{db.port}/{db.database}'
        dst = f'{interval}/{db.name}.{db.database}.{now.strftime("%Y%m%d-%H%M")}.pgdmp'
        loc = f'/{BACKUP_DIR}/{dst}' # YYYYMMDD-HHNN
        logging.debug(f'Backing up to: {loc}')
        subprocess.run(shlex.split(f'pg_dump -Fc --dbname={dbname} -f {loc} -v'), check=True)
        
        # also save to s3
        if backupToS3:
            upload(loc, dst)

    except Exception as e:
        logging.error(f'ERR: {e}')    

    return {'status': 'success', 'message': 'backup'}

# cleanup old files
def cleanup(folder: str):
    intervals = ['daily', 'weekly', 'monthly'] # don't mess with annually
    j = []
    try:
        for i in intervals:
            minTimestamp = int((now-timedelta(weeks=2)).strftime("%Y%m%d")) # 2 weeks 
            if i == 'weekly': minTimestamp = int((now-timedelta(weeks=26)).strftime("%Y%m%d")) # 2 months
            if i == 'monthly': minTimestamp = int((now-timedelta(weeks=104)).strftime("%Y%m%d")) # 2 years
            
            for f in listdir(f'/{BACKUP_DIR}/{i}'):
                try: 
                    if f.endswith('.pgdmp'):
                        timestamp = int(f.split('.')[2].split('-')[0])
                        if timestamp < minTimestamp:
                            logging.debug(f'deleting {f}')
                            try: 
                                remove(f'/{BACKUP_DIR}/{i}/{f}')
                                j.append(f'/{BACKUP_DIR}/{i}/{f}')
                                
                                # try to remove from s3
                                logging.debug(f'uploading {src} to {key}')
                                res = s3.Bucket(S3_BUCKET).delete_file(f'{i}/{f}')
                            except Exception as e: 
                                logging.error(e)
                                pass
                        else: logging.debug(f'skipping {f}')
                except:
                    pass

        return {'status': 'success', 'message': f'{len(j)} files deleted'}

    except Exception as e:
        logging.error(e)
        pass

### MAIN
if __name__ == '__main__':
    # backup sql servers
    for sql in SQL:
        res = backup(sql, args.interval)
        logging.info(res)

    # save daily for 2 weeks, weekly for 2 months, monthly for 2 years, annually    
    res = cleanup(SQL)
    logging.info(res)
