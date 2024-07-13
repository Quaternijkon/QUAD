#import "@preview/touying:0.4.2": *
#import "theme.typ"


#let s = theme.register(aspect-ratio: "16-9")
#let s = (s.methods.numbering)(self: s, section: "1.", "1.1")
#let s = (s.methods.info)(
  self: s,
  title: [QUAD],
  subtitle: [Typst模板],
  author: [Quaternijkon],
  date: datetime.today(),
  institution: [Institution],
)
#let (init, slides, touying-outline, alert) = utils.methods(s)
#let (slide, title-slide, focus-slide, matrix-slide, empty-slide) = utils.slides(s)