# geo_surveys_app

Mobile app for geocontrol surveys.

Uses the MVVM patern and features-first approach.

## Features

### tasks

Have two pages:

- TasksPage for view all tasks;
- TaskPage for review and execution task (read desription, check points, write report, take videos).

### auth

## To do

- S3 (for save videos not in db);
- auth module;
- Local DB (load to the smartphone on demand, try load to the DB e.g. once every hour).

## Сonnecting to the database

### For closed network (for real device)

1. You need to connect your computer and phone to the same network (?);
2. Add the line
   "host all all ip.ip.ip.ip/24 scram-sha-256"
   to the pg_hba.conf (change the ip);
3. Open port 5432 (default);
4. Change a host in DbModel (ip.ip.ip.ip).

### For emulator

The emulator can run in a closed network or on a localhost (host 10.0.2.2 in DbModel).
