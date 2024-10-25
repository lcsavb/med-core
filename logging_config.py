from logging.config import dictConfig

def configure_logging():
    dictConfig({
        'version': 1,
        'formatters': {
            'default': {
                'format': '[%(asctime)s] %(levelname)s in %(module)s: %(message)s',
            },
            'detailed': {
                'format': '[%(asctime)s] %(levelname)s in %(module)s: %(message)s',
            },
        },
        'handlers': {
            'console': {
                'class': 'logging.StreamHandler',
                'formatter': 'default',
                'level': 'DEBUG',
                'stream': 'ext://sys.stdout',
            },
            'file': {
                'class': 'logging.FileHandler',
                'formatter': 'detailed',
                'level': 'DEBUG',
                'filename': 'app.log',
            },
        },
        'root': {
            'level': 'DEBUG',
            'handlers': ['console', 'file']
        },
        'loggers': {
            'flask.app': {
                'level': 'DEBUG',
                'handlers': ['console', 'file'],
                'propagate': False
            },
            'werkzeug': {
                'level': 'INFO',
                'handlers': ['console'],
                'propagate': False
            },
        }
    })
