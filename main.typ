#import "/config.typ": *
#import "@preview/suiji:0.3.0": *
#import "lib.typ":*

#show: init
// #show strong: alert

#show strong: alert

// #show strong: it=>{
//   set text(fill: rgb("#EA4335"))
//   [#it]
// }

#show emph: it => {
  let colors = (
     rgb("#4285F4"),
     rgb("#34A853"),
     rgb("#FBBC05"),
     rgb("#EA4335"),
  )

  let i=1;
  let rng = gen-rng(it.body.text.len());
  let index_pre = integers(rng, low: 0, high: 4, size: none, endpoint: false).at(1);


  for c in it.body.text{
    let rng = gen-rng(i);
    let index_cur = integers(rng, low: 0, high: 4, size: none, endpoint: false).at(1);
    let cnt=100;
    while index_cur == index_pre and cnt>0{
      let rng = gen-rng(cnt);
      index_cur = integers(rng, low: 0, high: 4, size: none, endpoint: false).at(1);
      cnt -= 1;
    }
    let color = colors.at(index_cur);
    set text(fill: color)
    [#c]
    index_pre = index_cur;
    i += 1;

  }
  
  // for i in range(it.body.text.len()){
  //   let rng = gen-rng(i);
  //   let index = integers(rng, low: 0, high: 4, size: none, endpoint: false).at(1);
  //   let color = colors.at(index);
  //   let char = it.body.text.at(i);
  //   set text(fill: color)
  //   [#char]
  // }
}

#show: slides

#include "/content.typ"