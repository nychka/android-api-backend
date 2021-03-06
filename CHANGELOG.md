## 0.1.5 / 16.05.2015
### API
- add MAC field for user
- add route GET /users/:mac_address

## 0.1.4 / 25.04.2015
### API
- add user to bookmarks
- show bookmarked users
- remove user from bookmarks

## 0.1.3 / 24.03.2015
### API
- search nearby user by latitude and longitude
- show ads alongside nearby users

## 0.1.2 / 15.03.2015
### API
- show ad of the nearest place from user
- search nearby users

## 0.1.1 / 14.03.2015
### API
- add phone, latitude and longitude for user
- add latitude and longitude for ad

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