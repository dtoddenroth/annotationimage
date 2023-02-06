
# bratimage

Bundles the [Brat](http://http://brat.nlplab.org/) annotation tool
with configuration files and documents for a particular task. 

## Contents
 * `Dockerfile`: instructions for image building
 * `config/`: directory with templates for [Brat](http://http://brat.nlplab.org/) configuration files
 * `doc/`: directory with documents to be annotated (`.txt` and `.ann` files)

Building instructions copy files from `config/` and `doc/` to the image . 

## Conventions in `config.py`
 * Containers expect `BASE_DIR` to be `/brat`. 
 * `DATA_DIR` has do be `/brat/doc`. 
 * `WORK_DIR` has do be `/brat/work`.
 
Other options in `config.py` and `.conf` files [can be modified](https://brat.nlplab.org/configuration.html). 

## Set into motion

```
docker build -t brattask --target brattask .
docker run -p 8001:8001 brattask
```

## Notes

The utilized function `getargspec` from `inspect` 
was [removed in Python 3.11](https://docs.python.org/3/whatsnew/3.11.html#removed), 
so `python:3.10-alpine` serves as the base image. 

To work around a missing mime type for `xhtml` files, 
a makeshift entry is defined in `/etc/mime.types` 
(similar to issues [1202](https://github.com/nlplab/brat/issues/1202)
and [1366](https://github.com/nlplab/brat/issues/1366)). 

## Hints

Interactively inspect a container while exposing the predefined port (8001):
```
docker run -p 8001:8001 -it brattask sh
```

Extract annotations before shutting down, 
either by freezing files into another image via
 `docker commit` and `docker save`, or by copying directly from the container: 
```
docker container ls --all --filter=ancestor=brattask --format "{{.ID}}"
docker cp 00f498698374:/brat/doc/. ./outputs
```
or 
```
docker cp $(docker container \
ls --all --filter=ancestor=brattask \
--format "{{.ID}}"):/brat/doc/. ./outputs
```
