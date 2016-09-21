# TanukiKit

[![Build Status](https://travis-ci.org/nerdishbynature/TanukiKit.svg?branch=master)](https://travis-ci.org/nerdishbynature/TanukiKit)
[![codecov.io](https://codecov.io/github/nerdishbynature/TanukiKit/coverage.svg?branch=master)](https://codecov.io/github/nerdishbynature/TanukiKit?branch=master)

A Swift 2.0 API Client for the GitLab API.

## Name

The name derives from the GitLab logo [which is an abstraction](https://about.gitlab.com/about) of an [japanese racoon dog subspecies named Tanuki](https://en.wikipedia.org/wiki/Japanese_raccoon_dog). Too bad `GitLabKit` was already taken.

## Authentication

TanukiKit supports both, GitLab Cloud and self hosted GitLab.
Authentication is handled using Configurations.

There are two types of Configurations, `TokenConfiguration` and `OAuthConfiguration`.

### TokenConfiguration

`TokenConfiguration` is used if you are using Access Token based Authentication (e.g. the user
offered you an access token he generated on the website) or if you got an Access Token through
the OAuth Flow.

You can initialize a new config for `gitlab.com` as follows:

```swift
let config = TokenConfiguration("12345")
```

or for self hosted installations

```swift
let config = PrivateTokenConfiguration("12345", url: "https://gitlab.example.com/api/v3/")
```

After you got your token you can use it with `TanukiKit`

```swift
TanukiKit(config).me() { response in
  switch response {
  case .Success(let user):
    println(user.login)
  case .Failure(let error):
    println(error)
  }
}
```

### OAuthConfiguration

`OAuthConfiguration` is meant to be used, if you don't have an access token already and the
user has to login to your application. This also handles the OAuth flow.Please not that the `redirectURI` are completely arbitrary and are only necessary because GitLab does not support redirect URIs like `git2go://gitlab_oauth`.
When logging in you should present a `UIWebView` and look for your `redirectURI` being called.

You can authenticate an user for `gitlab.com` as follows:

```swift
let config = OAuthConfiguration(token: "<Your Client ID>", secret: "<Your Client secret>", redirect_uri: "https://oauth.example.com/gitlab_oauth")
config.authenticate()

```

or for self hosted installations

```swift
let config = OAuthConfiguration("https://gitlab.example.com/api/v3/", webURL: "https://gitlab.example.com/", token: "<Your Client ID>", redirect_uri: "https://oauth.example.com/gitlab_oauth")
```

After you got your config you can authenticate the user:

```swift
// AppDelegate.swift

config.authenticate()

func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
  config.handleOpenURL(url) { config in
    self.loadCurrentUser(config) // purely optional of course
  }
  return false
}

func loadCurrentUser(config: TokenConfiguration) {
  TanukiKit(config).me() { response in
    switch response {
    case .Success(let user):
      println(user.login)
    case .Failure(let error):
      println(error)
    }
  }
}
```

Please note that you will be given a `TokenConfiguration` back from the OAuth flow.
You have to store the `accessToken` yourself. If you want to make further requests it is not
necessary to do the OAuth Flow again. You can just use a `TokenConfiguration`.

```swift
let token = // get your token from your keychain, user defaults (not recommended) etc.
let config = TokenConfiguration(token)
TanukiKit(config).user("tanuki") { response in
  switch response {
  case .Success(let user):
    println(user.login)
  case .Failure(let error):
    println(error)
  }
}
```

## Users

### Get the authenticated user

```swift
TanukiKit().me() { response in
  switch response {
    case .Success(let user):
      // do something with the user
    case .Failure(let error):
      // handle any errors
  }
```

## Repositories

### Get repositories of authenticated user

```swift
TanukiKit().repositories() { response in
  switch response {
    case .Success(let repositories):
      // do something
    case .Failure(let error):
      // handle any errors
  }
}
```
