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
    const radio = event.currentTarget
    if (radio.checked) {
      radio.checked = false
      this.submit()
    } else {
      radio.checked = true
      this.submit()
    }
  }
}
