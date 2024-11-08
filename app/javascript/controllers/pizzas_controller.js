import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js";

export default class extends Controller {
  static values = {
    id: String
  }

  static targets =[
    "listItem", "dismissableListItem"
  ]

  connect() {
    console.log("pizzas_controller connect()");
    // console.log("listItemTargets", this.listItemTargets);
  }

  // BEGIN track toppings (JS state)
  // track which toppings have been added, prevent adding duplicate toppings
  _setCurrentToppingIds(value) {
    // memoize
    if (!this.currentToppingIds) {
      this.currentToppingIds = []
    }

    if (value) {
      this.currentToppingIds.push(value)
    }
  }

  _unsetCurrentToppingIds(value) {
    if (value) {
      this.currentToppingIds = this.currentToppingIds.filter(e => e !== value)
    }
  }

  toppingSubFormTargetConnected(element) {
    // console.log("toppingSubFormConnect", element);
    const newId = element.dataset.toppingId;
    if (newId) {
      this._setCurrentToppingIds(Number(newId));
    }
  }

  toppingSubFormTargetDisconnected(element) {
    // console.log("toppingSubFormDisonnect", element);
    const newId = element.dataset.toppingId;
    if (newId) {
      this._unsetCurrentToppingIds(Number(newId));
    }
  }
  // END track toppings

  // BEGIN dismiss newly added toppings (DOM form state)
  listItemTargetConnected() {
    // IMPROVE: this is running on initial render
    // console.log("listItemTargetConnected()");
    this.rebaseAssociationForms();
  }

  listItemTargetDisconnected() {
    // IMPROVE: this is running on initial render
    // console.log("listItemTargetdisonnected()");
    this.rebaseAssociationForms();
  }

  // as multiple new associated topping list items can be added and removed dynamically,
  // appended to the same list as list items for already persisted associations (on edit)
  // ensure that they all get unique form index values so nothing is overwriting anything
  // else in the params collection.
  rebaseAssociationForms() {
    console.log("rebaseAssociationForms()");

    for (let i = 0; i < this.listItemTargets.length; i++) {
      const currentListItem = this.listItemTargets[i];
      // console.log("currentListItem", currentListItem);

      let subFormInputs = currentListItem.querySelectorAll("input, select");
      // console.log("subFormInputs", subFormInputs);

      for (let ii = 0; ii < subFormInputs.length; ii++) {
        let input = subFormInputs[ii];
        // console.log("input", input);


        // Form fields look like this.  Adjust the name attr, so form will build associated collection params correctly.
        // <input value="1" autocomplete="off" type="hidden" name="pizza[pizza_toppings_attributes][2][topping_id]" id="pizza_pizza_toppings_attributes_2_topping_id">
        const inputName = input.getAttribute("name");
        // console.log(inputName);
        const newInputName = inputName.replace(/[0-9]/g, String(i));
        input.setAttribute("name", newInputName);

        const inputId = input.getAttribute("id");
        if (inputId) {
          const newInputId = inputId.replace(/[0-9]/g, String(i));
          input.setAttribute("id", newInputId);
        }
      }
    }
  }

  listItemDismiss(event) {
    const dismissableForm = event.srcElement.closest(".list-item");
    dismissableForm.remove();
  }
  // END dismiss newly added toppings

  // select dropdown dynamically adds to form array for associated toppings
  selectTopping(event) {
    event.preventDefault();
    event.stopPropagation();

    console.log("selectTopping()");
    const newId = event.currentTarget.value;

    console.log("newId", newId);

    let url = `/pizzas/${this.idValue}/select_topping`;
    if (newId && this.currentToppingIds && this.currentToppingIds.includes(Number(newId))) {
      // no-op
    } else {
      url += `?topping_id=${newId}`;
      const successful = this.turboGet(url);
      if (successful) {
        console.log("successful")
      }
    }
    event.currentTarget.value = "";
  }

  // call turbo_tream action
  async turboGet(url, callback) {
    // console.log("turboGet", url);

    // https://github.com/hotwired/stimulus/issues/689
    // https://fly.io/ruby-dispatch/turbostream-fetch/
    // https://github.com/rails/request.js#how-to-use
    const response = await get(url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html, text/html, application/xhtml+xml",
      },
    });

    if (response.ok) {
      // console.log("OK");
      if (callback) {
        callback();
      } else {
        return 1; // truthy
      }
    } else {
      console.debug(response);
      return; // falsy
    }
  }
}
