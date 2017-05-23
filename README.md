# Fluentd GoogleCloud Metadata Filter Pluging

The plugin uses the google cloud metadata api in [version 1(https://cloud.google.com/compute/docs/storing-retrieving-metadata)]

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