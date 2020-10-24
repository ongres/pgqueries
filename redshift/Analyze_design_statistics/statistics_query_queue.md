
This query returns these fields:



* querytxt: the query.
* class: [class of query](https://docs.aws.amazon.com/redshift/latest/dg/cm-c-wlm-system-tables-and-views.html#wlm-service-class-ids)
* slots: slots use by the query.
* queue_milseconds: time in the queue.
* queue_milseconds: execution's time.



```
        querytxt       | class | slots | queue_milseconds | exec_milseconds 
-----------------------+-------+-------+------------------+-----------------
 with s3client as...   |     4 |     1 |              759 |            1222

```

