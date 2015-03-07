## 0.1.1 / Unrealesed
### API
- add phone, lng, lat for user

### Admin
- join ads and places
- add authentications for users

## 0.1.0 / 7.03.2015
### Admin
- add admin authentication using devise
- CRUD users
- CRUD ads
- CRUD places

## 0.0.10 / 2.03.2015
### API
- improved User#add_social_provider by updating existing authentication
- add user dependence for authentications - if user will be destroyed all his authentications will be too

## 0.0.9 / 1.03.2015
### API
- add ad for GET /users/:id
- restrict request format to application/json
- add big photos e.g 200x200 for facebook and gplus

## 0.0.8 / 26.02.2015
### API
- add and update links

## 0.0.7 / 24.02.2015
### API
- check access_token inside user param when PUT /users
- remove errors for unrequired fields from response

## 0.0.6 / 21.02.2015
### API
- add GET /users/123
- changed route: /auth/create to: /users
- add PUT /users
- connect other social networks by email

## 0.0.5 / 18.02.2015
### API
- add date field: bdate
- change param socials to Array for response

## 0.0.4 / 14.02.2015
### API
- add additional fields to User: city, gender, photo, socials

## 0.0.3 / 10.02.2015
### API
- add authorization vkontakte

## 0.0.2 / 09.02.2015
### API
- add authorization by google plus

## 0.0.1 / 07.02.2015
### API
- add authorization by facebook