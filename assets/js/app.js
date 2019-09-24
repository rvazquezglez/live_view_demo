import css from "../css/app.css";
import { Socket } from "phoenix";
import LiveSocket from "../../deps/phoenix_live_view";
import { Sortable, Plugins } from "@shopify/draggable";

let Hooks = {};
Hooks.Board = {
  mounted() {
    const sortable = new Sortable(document.querySelectorAll(".stage__cards"), {
      draggable: ".card",
      mirror: {
        constrainDimensions: true
      },
      swapAnimation: {
        duration: 200,
        easingFunction: "ease-in-out"
      },
      plugins: [Plugins.SwapAnimation]
    });

    sortable.on("sortable:stop", event => {
      const source = event.data.dragEvent.data.source;
      const cardId = parseInt(source.getAttribute("data-card-id"));
      const newStageId = parseInt(
        event.data.newContainer.getAttribute("data-stage-id")
      );
      const newIndex = parseInt(event.data.newIndex);
      const cardPayload = {
        card: {
          id: cardId,
          stage_id: newStageId,
          position: newIndex
        }
      };
      console.log("Server sync", cardPayload);
      this.pushEvent("update_card", cardPayload);
    });
  }
};

let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks });
liveSocket.connect();
