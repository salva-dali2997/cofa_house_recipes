import { Controller } from "@hotwired/stimulus"

// Adds and removes ingredient rows on the recipe form without a page reload.
export default class extends Controller {
  static targets = ["container", "template"]

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, Date.now())
    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {
    event.preventDefault()
    const item = event.target.closest("[data-nested-form-target='item']")
    const destroyField = item.querySelector("input[name*='_destroy']")

    if (destroyField) {
      // Persisted record: mark for destruction on save instead of ripping it out of the DOM,
      // otherwise it would silently survive because no _destroy param would be submitted.
      destroyField.value = "1"
      item.hidden = true
    } else {
      item.remove()
    }
  }
}
