# Shard-Manager
An easy tool to manage shards on repl.it.
Sorry for the unprofessionality.

## Installation
This isn't a proper shard, because adding it as a shard defeats the purpose of this tool (simplifying shard installation on repl.it). Instead, simply copy `shard_manager.cr` into a new file on repl.it, or alternatively, download the file from github and upload it to repl.it. Then just `require "./shard_manager.cr"`, or whatever you decided to name the file.

Note: All methods are in the `Shards` namespace. If you need to change this, you can edit the module name on line 3 of `shard_manager.cr`.
## Getting Started
Note: To `puts` help, simply add `Shards.help` to your code.

In order to learn how to use the shard manager, this guide will teach you how to install two shards, `crest` and `kemal`.
1. Create a new shard for `crest` by adding `crest = Shards::Shard.new "crest"`.
2. Add another shard for `kemal`. `kemal = Shards::Shard.new "kemal"`
3. Create (or update) the `shard.yml` file with our shards. `Shard::Yml.make [crest, kemal]`
4. Lastly, make sure your shards are installed by using the `shard install` command (`system("shard install")`) or simply running `Shards::Yml.install`.

This process will generate your `shard.yml` file and update it using the default shards tool.
## Other Information
Please, report any bugs with the program in the Issues tab.
