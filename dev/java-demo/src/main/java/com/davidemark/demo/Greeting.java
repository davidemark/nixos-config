package com.davidemark.demo;

import lombok.Builder;
import lombok.Value;

/** Lombok generates the getters, equals, hashCode, toString and the builder: check that jdtls sees them. */
@Value
@Builder
public class Greeting {
  String name;
  String text;

  public static Greeting of(String name) {
    return Greeting.builder().name(name).text("Hello, " + name + "!").build();
  }
}
