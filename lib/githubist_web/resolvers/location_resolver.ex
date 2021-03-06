defmodule GithubistWeb.Resolvers.LocationResolver do
  @moduledoc false

  alias Githubist.GraphQLArgumentParser
  alias Githubist.Locations
  alias Githubist.Locations.Location

  def all(_parent, params, _resolution) do
    params =
      params
      |> GraphQLArgumentParser.parse_limit(max_limit: 81)
      |> GraphQLArgumentParser.parse_order_by()

    locations = Locations.all(params)

    {:ok, locations}
  end

  def get(_parent, %{slug: slug}, _resolution) do
    case Locations.get_location_by_slug(slug) do
      nil -> {:error, message: "Location with slug #{slug} could not be found.", code: 404}
      location -> {:ok, location}
    end
  end

  def get_stats(%Location{} = location, _params, _resolution) do
    stats = %{
      rank: Locations.get_rank(location)
    }

    {:ok, stats}
  end
end
