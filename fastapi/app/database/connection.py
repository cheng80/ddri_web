"""
데이터베이스 연결 설정
DDRI ddri_db MySQL 연결
"""

import os
import pymysql
from dotenv import load_dotenv

_env_path = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), '.env')
load_dotenv(dotenv_path=_env_path)

DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'cheng80.myqnapcloud.com'),
    'user': os.getenv('DB_USER', 'team0101'),
    'password': os.getenv('DB_PASSWORD', ''),
    'database': os.getenv('DB_NAME', 'ddri_db'),
    'charset': 'utf8mb4',
    'port': int(os.getenv('DB_PORT', '13306')),
}


def connect_db():
    """
    데이터베이스 연결
    
    Returns:
        pymysql.Connection: 데이터베이스 연결 객체
        
    Raises:
        pymysql.Error: 데이터베이스 연결 실패 시
    """
    try:
        conn = pymysql.connect(**DB_CONFIG)
        return conn
    except pymysql.Error as e:
        raise pymysql.Error(f"Database connection failed: {str(e)}") from e
