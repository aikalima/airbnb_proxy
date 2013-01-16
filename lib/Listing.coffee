init = (pageProcessor, body) ->
  $ = pageProcessor.load(body)

  hostingIdTag = body.match(/hostingId.*/g)
  if hostingIdTag == null
    return

  hostingId = new String(hostingIdTag).match(/\d+/g)[0]

  listing =
    hostingId: hostingId
    user: $(".name").children()[0]?.attribs.href.replace(/\/users\/show\//g, "")
    displayAddress: $("#display_address").text()
    nightlyPrice: new String(body.match(/nightlyPrice.*/g)).match(/\d+/g)[0]
    weeklyPrice: new String(body.match(/weeklyPrice.*/g)).match(/\d+/g)[0]
    monthlyPrice: new String(body.match(/monthlyPrice.*/g)).match(/\d+/g)[0]
    title: $("meta[property='og:title']").attr("content")
    description: $("meta[property='og:description']").attr("content")
    image: $("meta[property='og:image']").attr("content")
    zip: $("meta[property='airbedandbreakfast:postal-code']").attr("content")
    locality: $("meta[property='airbedandbreakfast:locality']").attr("content")
    region: $("meta[property='airbedandbreakfast:region']").attr("content")
    country: $("meta[property='airbedandbreakfast:country-name']").attr("content")
    city: $("meta[property='airbedandbreakfast:city']").attr("content")
    rating: $("meta[property='airbedandbreakfast:rating']").attr("content")
    latitude: $("meta[property='airbedandbreakfast:location:latitude']").attr("content")
    longitude: $("meta[property='airbedandbreakfast:location:longitude']").attr("content")
    fbId: $("meta[property='fb:app_id']").attr("content")
    roomType: $("#description_details li .value")[0]?.children[0].data
    bedType: $("#description_details li .value")[1]?.children[0].data
    sleeps: $("#description_details li .value")[2]?.children[0].data
    bedrooms: $("#description_details li .value")[3]?.children[0].data
    bathrooms: $("#description_details li .value")[4]?.children[0].data
    extraPeople: $("#description_details li .value #extra_people_price_string")[0]?.children[0]?.data
    #cleaningFee: new String($("#description_details li .value #cleaning_fee_price_string")[0]?.children[0]?.data).match(/\d+/g)?[0]
    searchQuery: $("#description_details li .value")[10]?.children[0].attribs?.href
    petOwner: $("#description_details li .value")[12]?.children[0].data

module.exports.init = init




