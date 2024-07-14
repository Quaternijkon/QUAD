#import "@preview/touying:0.4.2": *
#import "theme.typ"


#let s = theme.register(aspect-ratio: "16-9")
#let s = (s.methods.numbering)(self: s, section: "1.", "1.1")
#let s = (s.methods.info)(
  self: s,
  title: [什么年代了还在用传统幻灯片？],
  subtitle: [快来使用幻灯片界的⚪神Typst！],
  author: [Typst领域大神],
  date: datetime.today(),
  institution: [新艾丽都],
)
#let (init, slides, touying-outline, alert) = utils.methods(s)
#let (slide, title-slide, focus-slide, matrix-slide, empty-slide) = utils.slides(s)