"""
데이터베이스 연결 설정 (로컬 개발용)
DDRI ddri_db MySQL 로컬 연결
"""

import pymysql

DB_CONFIG = {
    'host': '127.0.0.1',
    'user': 'root',
    'password': '',
    'database': 'ddri_db',
    'charset': 'utf8mb4',
    'port': 3306
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
