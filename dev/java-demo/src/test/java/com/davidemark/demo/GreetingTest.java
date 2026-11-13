package com.davidemark.demo;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class GreetingTest {

  @Test
  void greetsByName() {
    Greeting greeting = Greeting.of("Davide");

    assertEquals("Hello, Davide!", greeting.getText());
  }

  @Test
  void keepsTheName() {
    assertEquals("Fabiola", Greeting.of("Fabiola").getName());
  }
}
