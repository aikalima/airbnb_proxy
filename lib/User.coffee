init = (pageProcessor, body) ->
  $ = pageProcessor.load(body)

  isUser = body.match(/initUserAttributes.*/g)
  if isUser == null
    return {'err'}


  user =
    name: $("meta[property='og:title']").attr("content")
    description: $("meta[property='og:description']").attr("content")
    image: $("meta[property='og:image']").attr("content")


module.exports.init = init




