defmodule FrontendWeb.Router do
  use FrontendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FrontendWeb do
    pipe_through :api
  end
end
