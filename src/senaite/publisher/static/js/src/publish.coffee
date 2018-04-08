import PublishAPI from './api.coffee'

import React from "react"
import ReactDOM from "react-dom"

import Button from "./component/Button.js"
import PaperFormatSelection from "./component/PaperFormatSelection.js"



class PublishController extends React.Component
  ###
   * Publish Controller
  ###

  constructor: (props) ->
    super(props)
    console.log "PublishController::constructor:props=", props

    @handleSubmit = @handleSubmit.bind(this)
    @handleChange = @handleChange.bind(this)

    @api = new PublishAPI()

    @state =
      items: @api.get_url_parameter("items").split(",")
      merge: no
      format: "A4"
      orientation: "portrait"
      template: "senaite.publisher:Default.pt"

  componentDidMount: ->
    console.debug "PublishController::componentDidMount"
    @api.render_reports
      items: @state.items.join(",")
      merge: @state.merge
      format: @state.format
      orientation: @state.orientation
      template: @state.template

  handleSubmit: (event) ->
    console.log "Form Submitted"
    event.preventDefault()

  handleChange: (event) ->
    target = event.target
    value = if target.type is "checkbox" then target.checked else target.value
    name = target.name

    console.info("PublishController::handleChange: name=#{name} value=#{value}")
    @setState
      [name]: value

  render: ->
    <div className="jumbotron">
      <form onSubmit={this.handleSubmit}>

        <hr className="my-4"/>

        <div className="form-group">
          <PaperFormatSelection api={@api} onChange={@handleChange} value={@state.format} className="custom-select" name="format" />
        </div>

      </form>
    </div>


document.addEventListener "DOMContentLoaded", ->
  console.debug "*** SENAITE.PUBLISHER::DOMContentLoaded"
  ReactDOM.render <PublishController />, document.getElementById "publish_controller"