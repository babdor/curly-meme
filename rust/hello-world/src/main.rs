#![deny(warnings)]
use warp::Filter;

#[tokio::main]
async fn main() {
    // Match any request and return hello world!
    let routes = warp::any().map(|| "Hello, World! -babd");

    warp::serve(routes).run(([0, 0, 0, 0], 8080)).await;
}
