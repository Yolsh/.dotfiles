from archinstall.lib.configuration import ConfigurationOutput
from archinstall.lib.args import arch_config_handler

if not arch_config_handler.args.silent:
    print('not silent')

config = ConfigurationOutput(arch_config_handler.config)
config.write_debug()