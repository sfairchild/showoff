defmodule ShowoffWeb.ScratchpadLive do
  use Phoenix.LiveView
  import Phoenix.HTML.Tag
  alias Showoff.{Examples, RecentDrawings}

  def mount(%{}, socket) do
    # if connected?(socket) do
      :ok = ShowoffWeb.Endpoint.subscribe("recent_drawings")
    # end

    socket = socket
             |> assign(:x, 0)
             |> assign(:y, 0)
             |> assign(:view_box, {0, 0, 100, 100})
             |> update_drawing("")
             |> assign(:drawing_text, "")
             |> assign(:err, "")
             |> assign(:recent, RecentDrawings.list())
    {:ok, socket}
  end

  def handle_event("draw", %{"drawing_text" => text}, socket) do
    socket = socket |> update_drawing(text) |> assign(:drawing_text, text)
    {:noreply, socket}
  end

  def handle_event("example", text, socket) do
    socket = socket |> update_drawing(text) |> assign(:drawing_text, text)
    {:noreply, socket}
  end

  def handle_event("zoom_out", _, %{assigns: %{x: x, y: y, view_box: {min_x, min_y, old_width, old_height}}} = socket) do
    new_width = old_width * 2
    new_height = old_height * 2
    socket = socket
             |> assign(:view_box, {x - ((new_width - 100) / 2), y - ((new_height - 100) / 2), new_width, new_height})
             |> update_drawing(socket.assigns.drawing_text)
    {:noreply, socket}
  end

  def handle_event("zoom_in", _, %{assigns: %{x: x, y: y, view_box: {min_x, min_y, old_width, old_height}}} = socket) do
    new_width = old_width / 2
    new_height = old_height / 2
    socket = socket
             |> assign(:view_box, {x - ((new_width - 100) / 2), y - ((new_height - 100) / 2), new_width, new_height})
             |> update_drawing(socket.assigns.drawing_text)
    {:noreply, socket}
  end

  def handle_event("move_left", _, %{assigns: %{x: x, view_box: {min_x, min_y, width, height}}} = socket) do
    socket = socket
             |> assign(:x, x + 5)
             |> assign(:view_box, {min_x + 5, min_y, width, height})
             |> update_drawing(socket.assigns.drawing_text)
    {:noreply, socket}
  end

  def handle_event("move_right", _, %{assigns: %{x: x, view_box: {min_x, min_y, width, height}}} = socket) do
    socket = socket
             |> assign(:x, x - 5)
             |> assign(:view_box, {min_x - 5, min_y, width, height})
             |> update_drawing(socket.assigns.drawing_text)
    {:noreply, socket}
  end

  def handle_event("move_up", _, %{assigns: %{y: y, view_box: {min_x, min_y, width, height}}} = socket) do
    socket = socket
             |> assign(:y, y + 5)
             |> assign(:view_box, {min_x, min_y + 5, width, height})
             |> update_drawing(socket.assigns.drawing_text)
    {:noreply, socket}
  end

  def handle_event("move_down", _, %{assigns: %{y: y, view_box: {min_x, min_y, width, height}}} = socket) do
    socket = socket
             |> assign(:y, y - 5)
             |> assign(:view_box, {min_x, min_y - 5, width, height})
             |> update_drawing(socket.assigns.drawing_text)
    {:noreply, socket}
  end

  def handle_event("reset", _, socket) do
    socket = socket
             |> assign(:x, 0)
             |> assign(:view_box, {0, 0, 100, 100})
             |> update_drawing(socket.assigns.drawing_text)
    {:noreply, socket}
  end

  def handle_event("publish", %{"drawing_text" => text}, socket) do
    case Showoff.text_to_drawing(text) do
      {:ok, drawing} ->
        RecentDrawings.add_drawing(drawing)
        {:noreply, assign(socket, :err, "")}
      {:error, _err} ->
        socket = socket |> assign(:err, "an error occured trying to draw that") |> assign(:drawing_text, text)
        {:noreply, socket}
    end
  end

  def handle_info(%{event: "update", payload: %{recent: recent}}, socket) do
    socket = assign(socket, :recent, recent)
    {:noreply, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="row">
    <h1>Scratchpad: Try Drawing Something!</h1>
    </div>

    <div class="row">
    <div class="screen" id="screen">
    <%= if @svg, do: {:safe, @svg} %>
    </div>
    <div class="input">
    <form phx-submit="publish" phx-change="draw">
    <textarea name="drawing_text"><%= @drawing_text %></textarea>
    <button name="action" value="publish">Publish This Drawing</button>
    <button name="zoom_out" phx-click="zoom_out">－</button>
    <button name="zoom_in" phx-click="zoom_in">✚</button>
    <button name="move_left" phx-click="move_left">⬅︎</button>
    <button name="move_right" phx-click="move_right">➡︎</button>
    <button name="move_up" phx-click="move_up">⬆︎</button>
    <button name="move_down" phx-click="move_down">⬇︎</button>
    <button phx-click="reset">RESET</button>
    </form>
    <p class="error"><%= @err %></p>
    <h4>Examples - Click to Try Them Out</h4>
    <div class="row examples">
    <%= for example <- Showoff.Examples.list() do %>
      <%= content_tag(:div, {:safe, example.svg}, class: "example", phx_click: "example", phx_value: example.text) %>
      <% end %>
    </div>
    </div>
    </div>

    <div class="row">
    <h1>Recent Published Drawings</h1>
    </div>

    <div class="row recents">
    <%= for recent <- @recent do %>
      <%= content_tag(:div, {:safe, recent.svg}, class: "example", phx_click: "example", phx_value: recent.text) %>
      <% end %>
      </div>
      """
  end

  defp update_drawing(socket, text) do
    view_box = socket.assigns.view_box
    case Showoff.text_to_svg(text, view_box) do
      {:ok, svg} ->
        assign(socket, :svg, svg)
      {:error, _err} ->
        assign(socket, :svg, nil)
    end
  end
end
