# Fluentd GoogleCloud Metadata Filter Pluging

[![Build Status](https://travis-ci.org/tourstream/fluent-plugin-gcloud-metadata.svg?branch=master)](https://travis-ci.org/tourstream/fluent-plugin-gcloud-metadata)


The plugin uses the google cloud metadata api in [version1](https://cloud.google.com/compute/docs/storing-retrieving-metadata)

## Installation
```bash
gem install fluent-plugin-gcloud-metadata
```

## plugin configuration
```
<filter **>
  @type gcloud_metadata
  <metadata>
    project_name project/project-id
    ...
  </metadata>
</filter>
```