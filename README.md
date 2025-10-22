# geo_surveys_app

Mobile app for geocontrol surveys.

Uses the MVVM patern and features-first approach.

## To do

- Local DB (load to the smartphone on demand, try load to the DB e.g. once every hour).
- Errors log.

## Features

### auth

- Main page.
- Simple authentication.
- It takes you to the TasksPage.

### tasks

- The TasksPage displays all the tasks in the card list.
- It takes you to the TaskPage and AuthPage.

### task

- You can view and complete the task on the TaskPage.
- It has a bottom navigation and three widgets (task, report, videos).
- It takes you to the TasksPage.

## Database administration

### Сonnecting to the database

- For closed network (real device):

  1.  You need to connect your computer and phone to the same network (?);
  2.  Add the line
      "host all all ip.ip.ip.ip/24 scram-sha-256"
      to the pg_hba.conf (change the ip);
  3.  Open port 5432 (default);
  4.  Change a host in DbModel (ip.ip.ip.ip).\

- The android emulator can run in a closed network or on a localhost (host 10.0.2.2 in DbModel).

### Test users

1. login = 'test_1', password = 'pas_1';
2. login = 'test_2', password = 'pas_2'.

### User create

- INSERT INTO public."user"(
  login, "password")
  VALUES ('login', crypt('password', gen_salt('bf')));

### Password update

- UPDATE public."user"
  SET password = crypt('password', gen_salt('bf'))
  WHERE login = 'login';

## Build

- Gradle version: android/gradle/wrapper/gradle-wrapper.properties distributionUrl;
- Gradle plugin version: android/gradle/settings.gradle "dev.flutter.flutter-gradle-plugin" and "com.android.application";
- Kotlin version: android/gradle/build.gradle ext.kotlin_version; android/gradle/settings.gradle "org.jetbrains.kotlin.android"
