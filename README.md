## Genome Fraction Bar Chart

### Description

This image builds a bar chart for genome fraction values.

### How to run?

You can make a test run by running the following steps:

1.Unzip the following 'test.tar.gz' package:

~~~BASH
tar xzvf test.tar.gz
~~~

2.Run the following command:

~~~BASH
docker run -v $(pwd)/test/input:/cami/test  -v $(pwd)/test/output:/output  pbelmann/genome-fraction-bar-chart  /project/bar_chart.r /cami/test/commits_info.tsv combined_reference/transposed_report.tsv
~~~

The output should contain the following files

* bioboxes.yaml: This is a file describing the produced output of the container.

* out.html: This file contains the output produced by the container. You can open it with your favorite browser.
