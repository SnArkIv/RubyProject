import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit() {
    this.element.requestSubmit()
  }

  debounce() {
    clearTimeout(this._timeout)
    this._timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 400)
  }

  toggleRadio(event) {
    event.preventDefault()
    const radio = event.currentTarget
    radio.checked = !radio.checked
    this.submit()
  }

  toggleAddress(event) {
    const field = this.element.querySelector("#address-field")
    if (!field) return
    if (event.target.value === "pickup") {
      field.style.display = "none"
    } else {
      field.style.display = "block"
    }
  }
}
