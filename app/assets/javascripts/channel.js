(function () {
  var dispatcher = new WebSocketRails("localhost:3000/websocket"),
      channel = dispatcher.subscribe("messages"),
      createMessage = $(".new-message"),
      newConversation = $(".new-conversation"),
      message = $("[name='message[new]']");

  dispatcher.on_open = function () {
    this.trigger("client_connected", "online");
  };

  dispatcher.bind("error", function (msg) {
    console.log(msg);
  });

  createMessage.on("submit", function (e) {
    e.preventDefault();
    var data = {
      comment: message.val(),
      user_id: message.data().userId
    };

    dispatcher.trigger("create", data);

    message.val("");
  });

  newConversation.on("submit", function (e) {
    e.preventDefault();
    var message = $("[name='conversation[new]'"),
        senderId = message.data("user-id"),
        receiverId = message.data("receiver-id"),
        data = {
          comment: message.val(),
          sender: senderId,
          receiver: receiverId
        };

    dispatcher.trigger("directmessage", data);

    message.val("");
  });

  // Refactor direct message binding and public message so that they both access one function
  // that handles the similar parts in both

  dispatcher.bind("dm", function (data) {
     var positioningContext = $(".time-period .message").first(),
        pElem = $("<p class='message'>"),
        username = $("<span class='username'>"),
        time = $("<span class='timestamp xs'>"),
        message = $("<span class='user-message'>");

    username.text(data.sender);
    time.text(data.time);
    message.text(data.comment);

    pElem.append(username).append(time).append(message);
    positioningContext.before(pElem);

    pElem.addClass("reveal");
  });

  channel.bind("new", function(data) {
    var positioningContext = $(".time-period .message").first(),
        pElem = $("<p class='message'>"),
        username = $("<span class='username'>"),
        time = $("<span class='timestamp xs'>"),
        message = $("<span class='user-message'>");

    username.text(data.username);
    time.text(data.time);
    message.text(data.comment);

    pElem.append(username).append(time).append(message);
    positioningContext.before(pElem);

    pElem.addClass("reveal");

  });

  // Refactor online and offline bindings so that they both access one function
  // that handles the similar parts in both

  channel.bind("online", function(data) {
    var displayContext = $(".online"),
        currentUser = $(".user-options").data("user"),
        link;

    $(".online-user").remove();

    data.forEach(function (item, index) {
      link = $("<a class='online-user' href='/conversation/" + item + "'>");
      link.text(item);
      if (item !== currentUser) displayContext.append(link);
    });

  });

  channel.bind("offline", function(data) {
    var displayContext = $(".online"),
        currentUser = $(".user-options").data("user"),
        link;

    $(".online-user").remove();

    data.forEach(function (item, index) {
      link = $("<a class='online-user' href='/conversation/" + item + "'>");
      link.text(item);
      if (item !== currentUser) displayContext.append(link);
    });

  });

}());