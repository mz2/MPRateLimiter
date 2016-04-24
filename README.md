# MPRateLimiter ![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)
A synchronous rate limiter for Swift: 

- Synchronous: makes the current thread wait (as opposed to dispatching in the future after throttling rate limit has passed).
- Public interface is thread safe.
- Allows for rethrowing errors thrown by the rate limited executed closure.

## Usage examples

```
let limiter = RateLimiter()
limiter.execute("foo", 0.1) {
  print("bar")
}
```
