# Funcml-cli

A CLI implementing funcml-core written in Ruby. Work in progress.

## Usage

```
bin/funcml-cli help
Commands:
  funcml-cli help [COMMAND]  # Describe available commands or one specific command
  funcml-cli render_all      # Renders all files in directory
  funcml-cli version         # Shows currently used versions of funcml
```

```bash
funcml-cli render-all \
    -d ./test/subtest/subsubtest \      # directory where templates are located
    -x json \                           # only select .json templates
    -m ./test/subtest/subsubtest/test.muy \ # mutation file written in YAML
    -m ./test/subtest/subsubtest/test.muj \ # mutation file written in JSON
    --no-output-stdout \                    # save results in files
    --output-directory ./output             # save results in ./output directory
    --output-format json                    # all results should be in JSON
```

## Development

The `funcml-core` Gem is required. If you wanna use the in-development version of `funcml-core`, clone this repository next to the `funcml-core` one and run the `funcml-cli` or its tests while setting the `LOCAL_DEV` environment variable.

```bash
git clone git@github.com/mimopotato/funcml-core
git clone git@github.com/mimopotato/funcml-cli
cd funcml-cli
LOCAL_DEV=true bin/funcml-cli help
```