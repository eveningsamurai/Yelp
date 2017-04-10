# Yelp
Codepath Assignment 2

# Project 2 - Yelp

Yelp is a Yelp search app using the [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: 15+ hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Search results page
   - [x] Table rows should be dynamic height according to the content height.
   - [x] Custom cells should have the proper Auto Layout constraints.
   - [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [x] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [x] The filters you should actually have are: category, sort (best match, distance, highest rated), distance, deals (on/off).
   - [x] The filters table should be organized into sections as in the mock.
   - [x] You can use the default UISwitch for on/off states.
   - [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   - [x] Display some of the available Yelp categories (choose any 3-4 that you want).

The following **optional** features are implemented:

- [] Search results page
   - [] Infinite scroll for restaurant results.
   - [] Implement map view of restaurant results.
- [] Filter page
   - [ ] Implement a custom switch instead of the default UISwitch.
   - [] Distance filter should expand as in the real Yelp app
   - [] Categories should show a subset of the full list with a "See All" row to expand. Category list is [here](http://www.yelp.com/developers/documentation/category_list).
- [] Implement the restaurant detail page.
  - [] only first cell implemented with autolayout constraints

## Walkthrough of all user stories

Walkthrough: General                         |  
:-------------------------------------------:|
![Video Walkthrough](yelp_animations2.gif)  |

GIF created with [LiceCap](http://www.cockos.com/licecap/)

## Notes

Complex project in terms of getting the filters working. Unable to fix all issues in getting the filters working 
Want to work more on getting this polished.

