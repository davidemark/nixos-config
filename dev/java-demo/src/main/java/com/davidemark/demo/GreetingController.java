package com.davidemark.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GreetingController {

  @GetMapping("/hello/{name}")
  public Greeting hello(@PathVariable String name) {
    // good place for a breakpoint: curl localhost:8080/hello/Davide
    return Greeting.of(name);
  }
}
