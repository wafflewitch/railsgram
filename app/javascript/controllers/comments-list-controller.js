// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus";
import consumer from "../channels/consumer";

export default class extends Controller {
  static targets = [
    "postId",
    "commentList",
    "blankslateText",
    "newCommentErrors",
    "textarea"
  ];

  connect() {
    this.setUpSubscription();
  }

  setUpSubscription() {
    consumer.subscriptions.create(
      {
        channel: "PostCommentChannel",
        post_id: this.postIdTarget.dataset.postId
      },
      {
        connected() {
        // Called when the subscription is ready for use on the server
        console.log("connected");
        },

        disconnected() {
        // Called when the subscription has been terminated by the server
        console.log("disconnected");
        },

        received: data => {
          switch(data.action) {
            case "created":
              this.handleNewComment(data);
            break;
            case "destroy":
              this.handleDeletedComment(data);
              break;
            default:
              console.log("no idea how to handle this action")
          }
        // Called when there's incoming data on the websocket for this channel
        }
      }
    )
  }

  handleNewComment(data) {
    if (this.blankslateTextTargets.length > 0) {
      this.blankslateTextTarget.remove();
    }

    this.commentListTarget.innerHTML += data.html;
  }

  handleDeletedComment(data) {
    const commentElement = document.querySelector(
      `[data-comment-id="comment_${data.comment_id}"]`
    );

    if (commentElement) {
      commentElement.remove();
    }
  }

  onPostError(event) {
    console.log('error');
    let [data, status, xhr] = event.detail;

    this.newCommentErrorsTarget.innerHTML = xhr.response;
  }

  onPostSuccess(event) {
    console.log('success');
    let [data, status, xhr] = event.detail;

    if (this.blankslateTextTargets.length > 0) {
      this.blankslateTextTarget.remove();
    }

    this.scrollToBottom();
    this.textareaTarget.value = "";
    this.newCommentErrorsTarget.innerHTML = "";
  }

  scrollToBottom() {
    const lastComment = this.commentListTarget.children.item(
      this.commentListTarget.children.length - 1
    );

    lastComment.scrollIntoView({
      behavior: "smooth",
      block: "start",
      inline: "nearest"
    })
  }
}
