from pathlib import Path

from tui import Tui
from lib.menu.abstract_menu import AbstractMenu
from lib.models.device_model import DiskLayoutConfiguration

def query_user():
    with Tui():
        hmm = AbstractMenu[DiskLayoutConfiguration]
        hmm.run()


