# MPRateLimiter ![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)
A synchronous rate limiter for Swift. 

- The current thread waits for the closure's rate limited execution (as opposed to the closure being dispatching into the future after potential throttling rate limit induced delay has passed). If you don't want this behaviour, you may want to try something like [DORateLimit](https://github.com/danydev/DORateLimit) instead.
- Public interface is thread safe.
- Allows for rethrowing errors thrown by the rate limited executed closure.

## Usage examples

```
let limiter = RateLimiter()
limiter.execute("foo", 0.1) {
  print("bar")
}
```
