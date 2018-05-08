var app = Elm.App.embed(document.querySelector("#elm-program"));

app.ports.outgoingModelDiffPort.subscribe(function(value){
  setTimeout(function(){
      app.ports.incomingModelPatchPort.send(value);
  }, 120);
});
