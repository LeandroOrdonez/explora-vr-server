from io import BytesIO
import numpy as np
import pandas as pd
import os
import json
import re
import time
import traceback
from instance.config import Config
from datetime import datetime

class QHandler():
    """This class represents an entity in charge of handling and processing queries issued to the API."""    

    def __init__(self):
        """initialize."""

    @staticmethod
    def get_video_tile(app_root_path, video_files_path, t_hor, t_vert, video_id, quality, filename):
        pass
        return