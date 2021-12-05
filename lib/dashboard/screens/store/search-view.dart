import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:narrid/dashboard/bloc/store/search/search_store_bloc.dart';
import 'package:narrid/dashboard/models/store/search/search_store_modal.dart';
import 'package:narrid/dashboard/repositories/store/search/store_search_repos.dart';
import 'package:narrid/dashboard/screens/store/categories/catalog.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (_) =>
              SearchStoreBloc(searchRepository: StoreSearchRepository()),
          child: Column(
            children: [
              BuildSearchField(),
              BuildSearchItems(),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildSearchItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchStoreBloc, SearchStoreState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchError) {
          return buildView("Oops, there was an error");
        } else if (state is SearchLoaded) {
          List<SearchModal> results = state.getResults;
          if (results.isEmpty) {
            return buildView("Oops, not found on our store");
          } else {
            return Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: results.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(9),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Catalog(
                                name: results[index].name,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Icon(
                                  Icons.search_off_rounded,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: AutoSizeText(
                                  results[index].name,
                                  maxLines: 1,
                                  wrapWords: true,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }
        } else if (state is Init) {
          return buildView("Search for products");
        }
      },
    );
  }

  Column buildView(String msg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SvgPicture.asset("assets/images/icons/empty-state-cart.svg"),
        SizedBox(height: 20),
        Text(
          "$msg",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w200,
          ),
        )
      ],
    );
  }
}

class BuildSearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "What are you looking for?",
                  border: InputBorder.none,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
                onChanged: (e) {
                  BlocProvider.of<SearchStoreBloc>(context, listen: false)
                    ..add(KeyUp(q: e));
                },
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.cancel,
            ),
          ),
        ),
      ],
    );
  }
}
