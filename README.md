
R/dynetNLAResistance
====================

R/dynetNLAResistance is an R package of anonymization algorithm to resist neighbor label attack in a dynamic network.

Installation
------------

You can install the stable version of R/dynetNLAResistance from CRAN:

``` r
install.packages("dynetNLAResistance")
```

Example
-------

You can create a dynamic network by function make.virtual.dynamic.network. Then group it by function lw.grouping,and anonymize it by function anonymization.

``` r
library(dynetNLAResistance)
dynet <- make.virtual.dynamic.network()
dynet.grouped <- lw.grouping(dynet,l = 2, w = 1)
```

    ## candidates number:  21  selected id:  V22987 
    ## Grouping t1 50%
    ## candidates number:  20  selected id:  V905 
    ## Grouping t1 100%
    ## merge.groups
    ## candidates number:  25  selected id:  V22987 
    ## Grouping t2 50%
    ## candidates number:  25  selected id:  V40271 
    ## Grouping t2 100%
    ## merge.groups
    ## candidates number:  30  selected id:  V64428 
    ## Grouping t3 50%
    ## candidates number:  29  selected id:  V40271 
    ## Grouping t3 100%
    ## merge.groups
    ## candidates number:  35  selected id:  V64428 
    ## Grouping t4 50%
    ## candidates number:  35  selected id:  V40271 
    ## Grouping t4 100%
    ## merge.groups
    ## candidates number:  39  selected id:  V64428 
    ## Grouping t5 33.33333%
    ## candidates number:  38  selected id:  V78667 
    ## Grouping t5 66.66667%
    ## candidates number:  38  selected id:  V40271 
    ## Grouping t5 100%
    ## merge.groups
    ## candidates number:  40  selected id:  V26750 
    ## Grouping t6 20%
    ## candidates number:  39  selected id:  V61271 
    ## Grouping t6 40%
    ## candidates number:  39  selected id:  V64428 
    ## Grouping t6 60%
    ## candidates number:  38  selected id:  V78667 
    ## Grouping t6 80%
    ## candidates number:  39  selected id:  V40271 
    ## Grouping t6 100%
    ## merge.groups
    ## candidates number:  43  selected id:  V26750 
    ## Grouping t7 16.66667%
    ## candidates number:  43  selected id:  V35010 
    ## Grouping t7 33.33333%
    ## candidates number:  42  selected id:  V22987 
    ## Grouping t7 50%
    ## candidates number:  39  selected id:  V78667 
    ## Grouping t7 66.66667%
    ## candidates number:  41  selected id:  V40271 
    ## Grouping t7 83.33333%
    ## candidates number:  38  selected id:  V8536 
    ## Grouping t7 100%
    ## merge.groups
    ## candidates number:  46  selected id:  V26750 
    ## Grouping t8 14.28571%
    ## candidates number:  46  selected id:  V35010 
    ## Grouping t8 28.57143%
    ## candidates number:  44  selected id:  V46066 
    ## Grouping t8 42.85714%
    ## candidates number:  45  selected id:  V22987 
    ## Grouping t8 57.14286%
    ## candidates number:  43  selected id:  V78667 
    ## Grouping t8 71.42857%
    ## candidates number:  45  selected id:  V40271 
    ## Grouping t8 85.71429%
    ## candidates number:  43  selected id:  V8536 
    ## Grouping t8 100%
    ## merge.groups
    ## candidates number:  49  selected id:  V26750 
    ## Grouping t9 12.5%
    ## candidates number:  49  selected id:  V35010 
    ## Grouping t9 25%
    ## candidates number:  48  selected id:  V46066 
    ## Grouping t9 37.5%
    ## candidates number:  49  selected id:  V22987 
    ## Grouping t9 50%
    ## candidates number:  47  selected id:  V78667 
    ## Grouping t9 62.5%
    ## candidates number:  46  selected id:  V905 
    ## Grouping t9 75%
    ## candidates number:  48  selected id:  V40271 
    ## Grouping t9 87.5%
    ## candidates number:  46  selected id:  V8536 
    ## Grouping t9 100%
    ## merge.groups
    ## candidates number:  53  selected id:  V26750 
    ## Grouping t10 12.5%
    ## candidates number:  53  selected id:  V35010 
    ## Grouping t10 25%
    ## candidates number:  52  selected id:  V46066 
    ## Grouping t10 37.5%
    ## candidates number:  53  selected id:  V22987 
    ## Grouping t10 50%
    ## candidates number:  51  selected id:  V78667 
    ## Grouping t10 62.5%
    ## candidates number:  51  selected id:  V14096 
    ## Grouping t10 75%
    ## candidates number:  51  selected id:  V40271 
    ## Grouping t10 87.5%
    ## candidates number:  50  selected id:  V8536 
    ## Grouping t10 100%
    ## merge.groups

``` r
g5.a <- anonymization(dynet.grouped$t5, alpha = 1, beta = 2, gamma = 3)
```

    ## Merged group-set's size:  3 
    ## Vertex number:  43 
    ## iterating...
    ## Anonymized nodes with sensitive label:
    ##  V97632 
    ## 
    ## Merged group-set's size:  2 
    ## Vertex number:  45 
    ## iterating...
    ## Anonymized nodes with sensitive label:
    ##  V97632 V20247 
    ## 
    ## Merged group-set's size:  1 
    ## Vertex number:  53 
    ## iterating...
    ## Anonymized nodes with sensitive label:
    ##  V97632 V20247 V97788

License
-------

MIT
