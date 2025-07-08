import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-loading"

const application = Application.start()
const context = definitionsFromContext(require.context("./controllers", true, /\.js$/))
application.load(context)
