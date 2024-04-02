package main

import (
    "testing"
)

func TestWelcome(t *testing.T) {
    w := Welcome{
        Name: "Test",
        Time: "12:00",
        Pod:  "PodTest",
    }

    if w.Name != "Test" {
        t.Errorf("Expected Name to be Test, got %s", w.Name)
    }

    if w.Time != "12:00" {
        t.Errorf("Expected Time to be 12:00, got %s", w.Time)
    }

    if w.Pod != "PodTest" {
        t.Errorf("Expected Pod to be PodTest, got %s", w.Pod)
    }
}