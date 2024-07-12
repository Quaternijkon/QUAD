#import "@preview/touying:0.4.0": *
#import "lib.typ"

#let s = lib.register(aspect-ratio: "16-9")
#let s = (s.methods.info)(
  self: s,
  title: [Title],
  subtitle: [Subtitle],
  author: [Authors],
  date: datetime.today(),
  institution: [Institution],
)
#let (init, slides, touying-outline, alert) = utils.methods(s)
#show: init

#let (slide, title-slide, focus-slide, matrix-slide) = utils.slides(s)
#show: slides

= First Section

== First Slide

#slide[
  A slide with a title and an *important* information.
]