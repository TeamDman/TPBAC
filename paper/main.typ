#import "@preview/charged-ieee:0.1.4": ieee
#import "@preview/glossarium:0.5.10": make-glossary, register-glossary, print-glossary

#show: ieee.with(
  title: [Teamy's Policy-Based Access Control (TPBAC)],
  abstract: [
    Software is governed by human rules for determining when attempted actions should be allowed and denied. I summarize common strategies and propose a formal set of common elements and extensions for building access control systems.
  ],
  authors: (
    (
      name: "TeamDman",
      //department: [Co-Founder],
      //organization: [Typst GmbH],
      location: [Ontario, Canada],
      email: "TeamDman9201@gmail.com"
    ),
  ),
  index-terms: ("Access Control", "RBAC", "ABAC", "PBAC", "TPBAC"),
  bibliography: bibliography("refs.bib"),
  figure-supplement: [Fig.],
)

#show: make-glossary

#show link: it => it

#let terminology = (
  (
    key: "game",
    short: "game",
    description: [
      A set of rules that govern state transitions from $T_0$ to $T_"END"$. Games need not terminate.
    ],
  ),
  (
    key: "player",
    short: "player",
    description: [A distinct unit according to the rules of a game.],
  ),
  (
    key: "match",
    short: "match",
    description: [
      A session of a game controlled by rules from a starting game state at $T_0$ to $T_"END"$.
    ],
  ),
  (
    key: "lobby",
    short: "lobby",
    description: [
      A set of parties for the purpose of engaging in matches. A lobby may be formed but not actively be engaged in a match.
    ],
  ),
  (
    key: "party",
    short: "party",
    description: [
      A non-empty set of players that can join and leave lobbies as a unit. Players are always in a party, even if the party only has one player. If a game does not inherently have a party system, it is equivalent to having a party system with a maximum party size of one player.
    ],
  ),
  (
    key: "matchmaking-queue",
    short: "matchmaking queue",
    description: [
      A system that matches parties together to form a lobby for the purpose of playing matches.
    ],
  ),
  (
    key: "clan",
    short: "clan",
    description: [
      A non-empty set of players for purposes of coordinating play and socialization, useful for filling parties and lobbies.
    ],
  ),
  (
    key: "friend",
    short: "friend",
    description: [
      A relationship between two players that have mutually agreed to be friends. This can be managed by a game (e.g., League of Legends) or by a game platform (e.g., Steam).
    ],
  ),
  (
    key: "invite",
    short: "invite",
    description: [A solicitation from one player to one or more other players to join a party.],
  ),
)

#register-glossary(terminology)

= Introduction

== Motivation

Consider a compute-constrained multiplayer environment using a client-server hub-and-spoke architecture. A server running a @match is responsible for evaluating an abstract machine code that powers a scripting language with inputs controlled by the clients. The server wants to ensure that @player:pl are not able to consume excessive resources due to malicious behaviour or, more likely, player oopsie-daisies. The server also wants to ensure that @player:pl are not able to cheat.

TODO: briefly explain the SFM logistics system, demonstrate how resources cannot be created or destroyed and are instead only moved from A to B. Translate from a recurisve execution to an abstract machine code that can have suspended execution to avoid consuming too much time per tick.

== Problem Statement

== Contributions

== Organization

= Background

== Cloud Service Providers

=== Azure

==== Security Groups (for Principals)

==== Network Security Groups (for Network Traffic)

==== Privileged Identity Management (PIM)

==== Azure Resource Manager Role Definitions and Role Assignments

- scopes, data-scopes, not-scopes, not-data-scopes
- (new-ish) conditions

==== Entra Role Definitions and Role Assignments

==== Entra Conditional Access Policies

== Terminology

#print-glossary(terminology, show-all: true, disable-back-references: true)

== Software Precedents

=== League of Legends

@Player:pl can join the @party:pl of @friend:pl without an @invite through.

The @party has a leader.

The @party leader can kick @player:pl from the @party.

The @party has a toggle that can block people from joining the @party without an @invite.

Only the @party leader can enqueue the @party for matchmaking.

When a @match is found, each @player is presented with "Accept Match" and "Decline" buttons along with a 30(todo: confirm) second countdown. The visual indicator for time remaining to accept feels like it has a grace period where the timer is at 0 but the @player can still accept the @match.

If any @player from any @party declines, the @match is cancelled and the @lobby is disbanded.

There are penalties for declining @match:pl and for abandoning @lobby:pl after accepting @match:pl.

=== Risk of Rain 2

The @party creation determines if the @lobby is "private", "friends-only", or "public". TODO: check if passwords are supported

The @party system has a ready-up system.

Once readied up, a @player cannot un-ready.

Once at least one @player has readied up, a 60 second countdown starts.

After the countdown, the @game starts regardless if all @player:pl are readied up or not.

=== The Finals

The @party leader can kick @player:pl from the @party.

The @party leader can enqueue the @party for matchmaking.

When a @match is found, an audio cue is played and @player:pl join the @lobby automatically.

The @lobby begins a @match without a ready-up system.

only host can start matchmaking, can look at the menus at least as a guest

=== Titanfall|2

=== Helldivers 2

anyone can queue a mission, waits for everyone to get in droppods

=== STAR WARS™ Battlefront™ II: Celebration Edition

anyone in the @lobby can start matchmaking 👍

=== osu

== Social Software

=== Syncplay

> Yes I know this may sound stupid but my beginner brain does not understand · Issue #413 · https://github.com/Syncplay/syncplay/issues/413

@lobby leader is for groupwatches, can't unready @friend:pl in small scenario

= Common Elements

== Actions

Actions are invocable discrete control flows within a software system. Actions have a unique identifier.

An action invocation attempt is a discrete initiation of the action execution pipeline by an actor.

An action invocation attempt is a tuple of an action id, an actor, and a context.

== Actors

Actors are discrete units of agency that can invoke actions. 

Each actor has a unique serializable identifier.

Details of an actor beyond the identifier are considered part of the context (e.g., userPrincipalName, client IP address, group affiliations, etc.) and are not inherent to the actor itself.

== Policies

A policy is a discrete object that contributes to the decision of whether an action invocation attempt should be allowed or denied.

A policy has a priority integer value. The set of policies is totally ordered using this `priority` value.

TODO: how to insert a policy between `priority=1` and `priority=2` without just using decimals

A policy has a predicate that determines if the policy matches a given action invocation attempt.

A policy has an outcome behaviour of either "allow" or "deny".

A policy has an enforcement behaviour of either "enforce" or "audit". The audit behaviour can be used to assess the impact of a policy without actually enforcing it, which is useful for testing and gradual rollouts.

The outcome of an action invocation attempt is determined by iteration through the set of policies; at least one allow-policy and no deny-policies must match the action invocation attempt for the outcome to be allow. If any deny-policy matches the action invocation attempt, the outcome is deny. If no policies match the action invocation attempt, the outcome is deny.

This follows the Principal of Least Privilege (no actor can do anything without explicit approval).

== Contexts

=== Global

Used for policy evaluation but not specific to any given action id.

=== Local - Parameters

Specific to a given action id.

= Extensions

== Impersonation

chain - impersonate another user, a group you are a member of, a scope hierarchy to inherit permissions

== Roles

== Scopes

== Groups

== Action Invocation Attempt Timestamps

== Action Invocation Attempt Identifiers

== Bucket-Refilling Rate Limiting

== Scripting Language Support

=== Open Policy Agent Rego

=== Lua

=== Rhai

=== Prolog

=== Alloy


// = Introduction
// Scientific writing is a crucial part of the research process, allowing researchers to share their findings with the wider scientific community. However, the process of typesetting scientific documents can often be a frustrating and time-consuming affair, particularly when using outdated tools such as LaTeX. Despite being over 30 years old, it remains a popular choice for scientific writing due to its power and flexibility. However, it also comes with a steep learning curve, complex syntax, and long compile times, leading to frustration and despair for many researchers @netwok2020 @netwok2022.
// 
// == Paper overview
// In this paper we introduce Typst, a new typesetting system designed to streamline the scientific writing process and provide researchers with a fast, efficient, and easy-to-use alternative to existing systems. Our goal is to shake up the status quo and offer researchers a better way to approach scientific writing.
// 
// By leveraging advanced algorithms and a user-friendly interface, Typst offers several advantages over existing typesetting systems, including faster document creation, simplified syntax, and increased ease-of-use.
// 
// To demonstrate the potential of Typst, we conducted a series of experiments comparing it to other popular typesetting systems, including LaTeX. Our findings suggest that Typst offers several benefits for scientific writing, particularly for novice users who may struggle with the complexities of LaTeX. Additionally, we demonstrate that Typst offers advanced features for experienced users, allowing for greater customization and flexibility in document creation.
// 
// Overall, we believe that Typst represents a significant step forward in the field of scientific writing and typesetting, providing researchers with a valuable tool to streamline their workflow and focus on what really matters: their research. In the following sections, we will introduce Typst in more detail and provide evidence for its superiority over other typesetting systems in a variety of scenarios.
// 
// = Methods <sec:methods>
// #lorem(45)
// 
// $ a + b = gamma $ <eq:gamma>
// 
// #lorem(80)
// 
// #figure(
  // placement: none,
  // circle(radius: 15pt),
  // caption: [A circle representing the Sun.]
// ) <fig:sun>
// 
// In @fig:sun you can see a common representation of the Sun, which is a star that is located at the center of the solar system.
// 
// #lorem(120)
// 
// #figure(
  // caption: [The Planets of the Solar System and Their Average Distance from the Sun],
  // placement: top,
  // table(
    // // Table styling is not mandated by the IEEE. Feel free to adjust these
    // // settings and potentially move them into a set rule.
    // columns: (6em, auto),
    // align: (left, right),
    // inset: (x: 8pt, y: 4pt),
    // stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    // fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0  { rgb("#efefef") },
// 
    // table.header[Planet][Distance (million km)],
    // [Mercury], [57.9],
    // [Venus], [108.2],
    // [Earth], [149.6],
    // [Mars], [227.9],
    // [Jupiter], [778.6],
    // [Saturn], [1,433.5],
    // [Uranus], [2,872.5],
    // [Neptune], [4,495.1],
  // )
// ) <tab:planets>
// 
// In @tab:planets, you see the planets of the solar system and their average distance from the Sun.
// The distances were calculated with @eq:gamma that we presented in @sec:methods.
// 
// #lorem(240)
// 
// #lorem(240)
