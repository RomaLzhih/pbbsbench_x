// This code is part of the Problem Based Benchmark Suite (PBBS)
// Copyright (c) 2011 Guy Blelloch and the PBBS team
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights (to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

bool report_stats = true;
int algorithm_version = 0;
// 0=root based, 1=bit based

#include <algorithm>
#include <math.h> 
#include <queue>
#include "parlay/parallel.h"
#include "parlay/primitives.h"
#include "common/geometry.h"
#include "k_nearest_neighbors.h"

/* compile with debug flags:
g++-11 -DHOMEGROWN -pthread -mcx16 -g -std=c++17 -I .  -include neighbors.h -o neighbors_debug ../bench/neighborsTime.C -fsanitize=address -fsanitize=undefined -DHOMEGROWN -pthread -ldl -L/usr/local/lib -ljemalloc

ASAN_OPTIONS=detect_leaks=0 PARLAY_NUM_THREADS=72 numactl -i all ./neighbors_debug -d 2 -k 1 -o oFile ../geometryData/data/2DinCube_10M
*/

// find the k nearest neighbors for all points in tree
// places pointers to them in the .ngh field of each vertex
template <int max_k, class vtx>
void ANN(parlay::sequence<vtx*> &v, int k, int p, double trial_time, int update_percent, bool do_check) {
  timer t("ANN",report_stats);

  {
    using knn_tree = k_nearest_neighbors<vtx, max_k>;
    using point = typename knn_tree::point;
    using node = typename knn_tree::node;
    using box = typename knn_tree::box;
    using box_delta = std::pair<box, double>;
  
#ifdef Versioned
    std::cout << "using multiversioning" << std::endl;
#else
    std::cout << "without multiversioning" << std::endl;
#endif

#ifndef NoHelp
    std::cout << "using lock-free locks" << std::endl;
#else
    std::cout << "using blocking locks" << std::endl;
#endif

#ifdef HandOverHand
    std::cout << "using hand-over-hand locking" << std::endl;
#else
    std::cout << "using path locking" << std::endl;
#endif

#ifdef PathCopy
    std::cout << "using path copying" << std::endl;
#else
    std::cout << "no path copying" << std::endl;
#endif
    if(algorithm_version == 0) std::cout << "root based algorithm" << std::endl;
    else if(algorithm_version == 1) std::cout << "bit based algorithm" << std::endl;

    //std::cout << "threads: " << num_threads << std::endl;

    //calculate bounding box around the whole point set
    box whole_box = knn_tree::o_tree::get_box(v);     
    knn_tree T(v, whole_box);
    t.next("build tree");

    //prelims for insert  
    int dims = v[0]->pt.dimension();

    // // delete v2 in parallel
    parlay::parallel_for(0, v2.size(), [&] (size_t j) {
      T.delete_point(v2[j]);
    }, 100, true);

    t.next("deletes");
    
    // EXAMPLE OF EQUALITY CHECKING
    knn_tree R(v1, whole_box);
    T.are_equal(R.tree.load(), dims);    
    t.next("equality check");
    // END EXAMPLE

    // insert v2 in parallel
    parlay::parallel_for(0, parlay::num_workers(), [&] (size_t i) {
      for(int j = i; j < v2.size(); j+=parlay::num_workers()) {
        T.insert_point(v2[j]); 
      }
    }, 1, true);

    t.next("inserts");
    
    // EXAMPLE OF EQUALITY CHECKING
    knn_tree R2(v, whole_box);
    T.are_equal(R2.tree.load(), dims);    
    t.next("equality check");
    // END EXAMPLE

    if (report_stats) 
      std::cout << "depth = " << T.tree.load()->depth() << std::endl;
      
    // find nearest k neighbors for each point
    parlay::parallel_for (0, n, [&] (size_t i) {
        T.k_nearest(v[i], k);
    }, 1);


    t.next("try all");
    if (report_stats) {
      auto s = parlay::delayed_seq<size_t>(v.size(), [&] (size_t i) {return v[i]->counter;});
      size_t i = parlay::max_element(s) - s.begin();
      size_t sum = parlay::reduce(s);
      std::cout << "max internal = " << s[i] 
		<< ", average internal = " << sum/((double) v.size()) << std::endl;
      t.next("stats");
    }
    t.next("delete tree");   


};
}

