<details><summary>Where is the data stored for the applications?</summary>
 <p>
  Data stored for the applications are stored into Elasticsearch (metrics, traces…)
  </p>
</details>

<details><summary>Which are the required ports to be exposed Publicly?</summary>
<p>
 
- If you use PM2 Enterprise with the HTTP configuration, the port 80 is the only one needed
- If you use PM2 Enterprise with the HTTPs configutation, the port 443 is the only one needed
 </p>
</details>



<details><summary>I get a error about `Unknown modifier: $pushAll`</summary>
 <p>
  We only support mongodb up to version 3.4 for now, you need to downgrade.
  </p>
</details>

<details><summary>How do I connect PM2 Runtime to PM2 Enterprise on-premise?</summary>
 <p>
 When you first register, you should have a bucket created automatically, then you will have connection data in the middle in this format : 

```
> KEYMETRICS_NODE=<your KM_SITE_URL> pm2 link <identifier_one> <identifier_two>
```

You have two way to link your pm2 : 
  - Connect to the instance where pm2 is and run the command.
  - If you have container, just add these environements variables :
    - `KEYMETRICS_PUBLIC`: replace with `identifier_two>`
    - `KEYMETRICS_SECRET`: replace with `<identifier_one>`
    - `KEYMETRICS_NODE`: replace with `<your KM_SITE_URL>`
    - `INSTANCE_NAME`: (optional) replace it if you want your server in keymetrics to have a fixed name
  </p>
</details>


<details><summary>How can monitor my apps inside containers without PM2?</summary>
 <p>
  You can use our nodejs agent without PM2, see the documentation there : https://pm2.io/doc/en/enterprise/collector/standalone/

  </p>
</details>


<details><summary>How can I disable the wizard?</summary>
 <p>
For your own credentials security, you should stop the wizard container. You can restart it when you want if you need to change the configuration
`docker-compose stop km-wizard`
  </p>
</details>

