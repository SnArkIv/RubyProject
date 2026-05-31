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
}
