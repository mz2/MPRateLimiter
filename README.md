# MPRateLimiter ![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)
A synchronous rate limiter for Swift. 

- The current thread waits for the closure's rate limited execution.
- Public interface is thread safe.
- Allows for rethrowing errors thrown by the rate limited executed closure.

If you don't want this behaviour where waiting is done synchronously, and instead need rate limiting of the sort where rate limited execution may be dispatched asynchronously in another call stack, you may want to try something like [DORateLimit](https://github.com/danydev/DORateLimit) instead.

## Usage examples

```
let limiter = RateLimiter()

// Executes at the maximum rate of 0.1s since the previously executed closure with matching key "foo"
limiter.execute(key:"foo", rateLimit:0.1) {
  print("bar")
}
```
