#  API Architecture

This document covers the basics of the API architecture.

## Requirements

This guide assumes a certain level of domain knowledge regarding the API. It is meant to give newcomers an overview
of how the system is built, and how its parts come together to provide the services the API offers.

This document doubles-down as an installation guide - just follow the instructions 
linked in each component's section. If you use is as such, keep in mind that it assumes you have installed 
and configured Docker (inc. Docker Compose) on your system.
It also assumes you are familiar with Docker, and are able to make the necessary changes to configuration
to account for differences in host systems. Depending on your host OS, you may need to make adjustments on parts
of the configuration in order to get it up and running.

Before proceeding, it's important to be aware that this API is built as a set of small parts, each with its own purpose and installation
process. This guide will cover the different components of the API, and is meant to be a starting point, rather than an extensive
list of instructions. Many additional details on the installation of the different components will be found elsewhere, 
particularly on the README.md of each components, and this guide does not replace those instructions.

Last, but not least, this installation process will be long and will require reading documentation on multiple repositories.
It assumes and thanks you for your patience.


## API Architecture


### Control Tower

The API is based on a microservices architecture, where different components "talk" to each other using internal HTTP requests.
At the center of this system is [Control Tower](https://github.com/control-tower/control-tower) component, which you need to install first, and
always have online while any other service is running. 

It's worth keeping in mind that Control Tower is domain-agnostic. It has multiple responsibilities:
- Manage other microservices: all microservices must register their services on Control Tower for 
them to be accessible. 
- Gateway: All requests originating from end users are handled by Control Tower, which then queries
other services to perform the actual actions and generate a response.
- User management: user authentication, logging and usage metrics are handled by Control Tower.
- Load balancing: Control Tower can manage multiple instances of the same service, splitting work between them

For installation instructions, please see [this page](https://github.com/control-tower/control-tower).


### Dataset

The core of the domain logic of the API is held by the [Dataset](https://github.com/GPSDD/dataset) component.
It stores the core information about a dataset (not to be confused with dataset metadata, or the actual dataset data),
like name, description, status, connector type and such. The dataset component has in itself the core functionality
needed to host a dataset on the API, but many dataset types require type-specific connectors to function
properly (Carto, GEE, Document, etc). As much as possible, type-specific logic is kept out of the dataset
component, and inside each component's code. However, this abstraction is not fully achieved, and the
dataset component does contain some logic regarding specific types of datasets. Additionally, the
dataset component implements validation and type whitelisting, meaning that adding a new dataset type
will always require minor changes to the dataset component.

As implicit above, all other API components require the logic contained in the dataset component, so be sure
to have it up and running before using other components of the API.

For installation instructions, please see [this page](https://github.com/GPSDD/dataset).


### Metadata

The [Metadata](https://github.com/GPSDD/rw_metadata) component, like the name suggests, stores and manages
the metadata for each dataset. It has no special requirements or dependencies on other components besides 
dataset and control tower.

For installation instructions, please see [this page](https://github.com/GPSDD/rw_metadata).


### Vocabulary

The [Vocabulary](https://github.com/GPSDD/vocabulary-tag) system allows creating vocabularies and tags,
and associating them with datasets.

For installation instructions, please see [this page](https://github.com/GPSDD/vocabulary-tag).


### Graph

The [Graph](https://github.com/GPSDD/graph-client) component extends the Vocabulary functionality by
means of a Neo4J graph database. It does so partially by means of a reserved "knowledge_graph" vocabulary,
which is both a "traditional" vocabulary and a graph-powered vocabulary.

Besides integrating with the Vocabulary component, it also provides several functions of its own,
that allow harnessing the power provided by a graph database.

For installation instructions, please see [this page](https://github.com/GPSDD/graph-client).


### Dataset type connectors

As mentioned in the dataset description, each dataset type has its own component, which implements as much as
possible of that type's logic. Currently, the following data types are available:
- [Carto](https://github.com/GPSDD/rw-adapter-carto)
- [Big Query](https://github.com/GPSDD/adapter-bigquery)
- [Document](https://github.com/GPSDD/document-adapter)
- [ArcGIS](https://github.com/GPSDD/adapter-arcgis)
- [Google Earth Engine](https://github.com/GPSDD/adapter-earth-engine)


### Query

The dataset types above support querying the data available in them directly through the API. The shared core
implementation of the query functionality is centralized in the [Query](https://github.com/GPSDD/query)
component, which you will need to use in case you want to access the data stored in these datasets.

For installation instructions, please see [this page](https://github.com/GPSDD/query).


### Dataset type connectors - index

Besides the dataset types above, there are other dataset types that are supported but only in index mode - thus
not supporting querying. These are:
 
- [RW](https://github.com/GPSDD/resource-watch-index-adapter)
- [WB](https://github.com/GPSDD/world-bank-index-adapter)
- [HDX](https://github.com/GPSDD/hdx-index-adapter)

Unlike their full-featured peers, these datasets do not support querying, and thus do not require the
Query component to fully function. However, they do update metadata automatically, something that is not
done by the other dataset type connectors, which is why they require the Metadata component.


### GeoStore

Some datasets types supported by the API are oriented towards querying geospatial data. However, geospatial 
queries can become large and complex if users have to encode the geometries in it every time. The GeoStore
component addresses this issue by allowing users to save and reuse geometries, instead of having to provide
them on each query.

For installation instructions, please see [this page](https://github.com/GPSDD/geostore).
